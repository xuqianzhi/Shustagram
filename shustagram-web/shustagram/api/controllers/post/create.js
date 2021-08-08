module.exports = async function (req, res) {
    const postBody = req.body.postBody
    console.log("Create post object with text: " + postBody);
    let userId = req.session.userId
    const file = req.file('imagefile');

    if (file.isNoop) {
        // Uncomment this if populating posts
        // if (req.body.populateUserId) {
        //     console.log("populating for user id: ", req.body.populateUserId)
        //     userId = req.body.populateUserId
        // }
        // const postRecord = await Post.create({
        //     text: postBody,
        //     user: userId,
        // }).fetch()
        // await FeedItem.create({
        //     post: postRecord.id,
        //     postOwner: userId,
        //     user: userId,
        //     postCreatedAt: postRecord.createdAt
        // })
        file.upload({noop: true})
        return res.end()
    }

    try {
        const fileUrl = await sails.helpers.uploadfile(file)
    
        const postRecord = await Post.create({
            text: postBody, 
            user: userId,
            imageUrl: fileUrl
        }).fetch()

        // creating feeditem for self
        await FeedItem.create({
            post: postRecord.id,
            postOwner: userId,
            user: userId,
            postCreatedAt: postRecord.createdAt
        })

        // insert a FeedItem for all followers
        const user = await User.findOne({id: userId}).populate('followers')
        user.followers.forEach(async f => {
            // console.log(f.fullName)
            await FeedItem.create({
                post: postRecord.id,
                postOwner: userId,
                user: f.id,
                postCreatedAt: postRecord.createdAt
            })
        })
    
        return res.redirect('/post')
    } catch (err) {
        res.serverError(err.toString())
    }
}