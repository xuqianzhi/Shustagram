module.exports = async function(req, res) {
    const postId = req.param('id')
    console.log("Create comment here: " + postId)

    // store a comment in our database
    await Comment.create({
        text: req.body.text,
        post: postId,
        user: req.session.userId
    })

    res.redirect('/post/' + postId)
}