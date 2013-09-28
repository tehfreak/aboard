module.exports= (App, Account, AccountGithub, User, UserPermission, auth, log) ->
    class AwesomeApiV1 extends App



        @loadUser: () -> (req, res, next) ->
            account= req.account
            if not req.isAuthenticated()
                req.user= User.getByName 'anonymous', req.maria
            else
                req.user= User.getById account.userId, req.maria
            req.user (user) ->
                    res.user= user
                    next()
            ,   (err) ->
                    res.errors.push res.error= err
                    next(err)



        @loadUserPermission: () -> (req, res, next) ->
            req.user (user) ->
                log 'load user permissions', user

                req.user.permissions= UserPermission.query user, req.maria
                req.user.permissions (permissions) ->
                        res.user.permissions= permissions
                        next()
                ,   (err) ->
                        res.errors.push res.error= err
                        next(err)



        @authUser: () -> (req, res, next) ->
            handler= auth.authenticate 'local', (err, account) ->
                if not account
                    return res.json 400, account
                account= Account.auth account, req.maria
                account (account) ->
                    if not account
                        return res.json 400, account
                    req.login account, (err) ->
                        return next err
            return handler req, res, next



        @authUserGithub: () -> (req, res, next) ->
            handler= auth.authenticate 'github', (err, account) ->
                account= AccountGithub.auth account, req.maria
                account (account) ->
                    if not account
                        res.json 400, account
                    else
                        req.login account, (err) ->
                            next err
            handler req, res, next



        @queryUser: () ->
            (req, res, next) ->
                query= req.query

                log 'queryUser', query

                req.users= User.query query, null
                req.users (users) ->
                        res.users= users
                ,   (err) ->
                        res.errors.push res.error= err

                do next



        @updateUser: () -> (req, res, next) ->
            userId= req.account.userId

            req.user= User.update userId, req.body, req.maria
            req.user (user) ->
                    res.user= user
            ,   (err) ->
                    res.errors.push res.error= err

            do next



        @updateAccount: () -> (req, res, next) ->
            accountId= req.account.id

            req.account= Account.update accountId, req.body, req.maria
            req.account (account) ->
                    res.account= account
            ,   (err) ->
                    res.errors.push res.error= err

            do next
