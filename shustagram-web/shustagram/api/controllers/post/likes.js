module.exports = async function(req, res) {
    const likes = await Like.find({post: req.param('id')})
        .populate('user')
    if (req.wantsJSON) {
        return res.send(likes)
    }
    res.view('pages/post/likes', {
        likes,
        layout: 'layouts/nav-layout'
    })
}