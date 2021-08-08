module.exports = async function (req, res) {
    const loggedinId = req.session.userId;
    const users = await User.find({
        id: { '!=': req.session.userId }
    }).sort('createdAt')

    const loggedinUser = await User.findOne({ id: loggedinId }).populate("following")

    // set isFollowing attribute
    const followingUsers = new Set()
    loggedinUser.following.forEach(f => {
        followingUsers.add(f.id)
    })

    const sanitizedUsers = JSON.parse(JSON.stringify(users))
    sanitizedUsers.forEach(user => {
        if (followingUsers.has(user.id)) {
            user.isFollowing = true
        }
    })

    if (req.wantsJSON) {
        return res.send(sanitizedUsers)
    }

    res.view('pages/user/search', {
        layout: 'layouts/nav-layout',
        users: sanitizedUsers
    })
}