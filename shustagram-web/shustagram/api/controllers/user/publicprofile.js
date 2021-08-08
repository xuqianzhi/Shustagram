module.exports = async function (req, res) {
    const id = req.param("id")
    console.log("Showing public profile of clicked user " + id)

    const loggedinUserId = req.session.userId

    const clickedUser = await User.findOne({ id: id })
        .populate('following')
        .populate('followers')

    const postsOfClickedUser = await Post.find({ user: id })
        .populate('user')
        .sort('createdAt DESC')

    for (let i = 0; i < postsOfClickedUser.length; i++) {
        const p = postsOfClickedUser[i]
        if (p) {
            const hasLiked = await Like.findOne({ post: p.id, user: loggedinUserId })
            p.hasLiked = hasLiked ? true : false
        }
    }

    clickedUser.posts = postsOfClickedUser

    var isFollowing = false // is being followed by logged in user

    clickedUser.followers.forEach(f => {
        if (f.id === req.session.userId) {
            isFollowing = true
        }
    })

    const sanitizedUser = JSON.parse(JSON.stringify(clickedUser))

    sanitizedUser.isFollowing = isFollowing

    if (req.wantsJSON) {
        return res.send(sanitizedUser)
    }

    res.view('pages/user/publicprofile', {
        layout: 'layouts/nav-layout',
        user: sanitizedUser,
    })
}