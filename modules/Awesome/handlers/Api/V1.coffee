module.exports= (App, Account, AccountGithub, Profile, auth, log) ->
    class AwesomeApiV1 extends App



        @loadProfile: () -> (req, res, next) ->
            if req.isAuthenticated()
                profileId= req.account.profileId
                req.profile= Profile.getById profileId, req.maria
            else
                req.profile= Profile.getByName 'anonymous', req.maria
            req.profile (profile) ->
                    res.profile= profile
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



        @queryProfile: () -> (req, res, next) ->
            query= req.query

            req.profiles= Profile.query query, req.maria
            req.profiles (profiles) ->
                    res.profiles= profiles
            ,   (err) ->
                    res.errors.push res.error= err

            do next


        @updateProfile: () -> (req, res, next) ->
            profileId= req.account.profileId

            req.profile= Profile.update profileId, req.body, req.maria
            req.profile (profile) ->
                    res.profile= profile
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
