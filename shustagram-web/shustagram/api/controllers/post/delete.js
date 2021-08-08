module.exports = async function (req, res) {
    const postId = req.param('postId');
    console.log("deleting post with id: ", postId);
    const userId = req.session.userId;
    try {
        await Post.destroy({ id: postId, user: userId })
        await FeedItem.destroy({ post: postId })
        await Comment.destroy({ post: postId })
        await Like.destroy({ post: postId })
        res.end()
    } catch (err) {
        res.serverError(err.toString())
    }
}