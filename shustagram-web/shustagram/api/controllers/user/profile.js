module.exports = async function (req, res) {

    const userId = req.session.userId
    console.log("showing personal profile of user: ", userId)

    const currentUser = await User.findOne({ id: userId })
        .populate('following')
        .populate('followers')

    const posts = await Post.find({ user: userId })
        .populate('user')
        .sort('createdAt DESC')

    for (let i = 0; i < posts.length; i++) {
        const p = posts[i]
        if (p) {
            const hasLiked = await Like.findOne({ post: p.id, user: userId })
            p.hasLiked = hasLiked ? true : false
            p.canDelete = true
        }
    }

    currentUser.posts = posts

    if (req.wantsJSON) {
        return res.send(currentUser)
    } 

    // customToJSON
    const sanitizedUser = JSON.parse(JSON.stringify(currentUser))

    res.view('pages/user/profile', {
        layout: 'layouts/nav-layout',
        user: sanitizedUser
    })
}