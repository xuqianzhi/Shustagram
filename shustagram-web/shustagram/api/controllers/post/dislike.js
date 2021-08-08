module.exports = async function(req, res) {
    console.log("disliking the post")
    const postId = req.param('id')
    try {
        await Like.destroy({
            post: postId,
            user: req.session.userId
        })

        const numLikes = await Like.count({post: postId})

        await Post.update({
            id: postId
        }).set({numLikes: numLikes})

        
        res.end()
    } catch (err) {
        res.serverError(err.toString())
    }
}