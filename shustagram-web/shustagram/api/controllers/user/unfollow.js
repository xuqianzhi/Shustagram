module.exports = async function (req, res) {
    const currentUserId = req.session.userId
    const userIdToUnfollow = req.param('id')

    await User.removeFromCollection(currentUserId, 'following', userIdToUnfollow)
    await User.removeFromCollection(userIdToUnfollow, 'followers', currentUserId)

    await FeedItem.destroy({ user: currentUserId, postOwner: userIdToUnfollow })

    res.end()
}