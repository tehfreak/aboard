module.exports= (App, Account, AccountGithub, User, auth, log) ->
    class AwesomeApiV1 extends App



        @loadUser: () -> (req, res, next) ->
            account= req.account

            req.user= User.getById account.userId, req.maria
            req.user (user) ->
                    res.user= user
            ,   (err) ->
                    res.errors.push res.error= err

            do next



        @authUser: () -> (req, res, next) ->
            handler= auth.authenticate 'local', (err, account) ->
                account= Account.auth account, req.maria
                account (account) ->
                    if not account
                        res.json 400, account
                    else
                        req.login account, (err) ->
                            next err
            handler req, res, next



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
