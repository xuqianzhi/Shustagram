module.exports = async function(req, res) {
    const currentUserId = req.session.userId
    const userIdToFollow = req.param('id')
    console.log('User id to follow: ' + userIdToFollow)

    await User.addToCollection(currentUserId, 'following', userIdToFollow)
    await User.addToCollection(userIdToFollow, 'followers', currentUserId)

    // Feed: find all posts of users that is currently following
    const postsForUserImFollowing = await Post.find({user: userIdToFollow})
    postsForUserImFollowing.forEach(async p => {
        await FeedItem.create({
            post: p.id,
            postOwner: userIdToFollow,
            user: currentUserId,
            postCreatedAt: p.createdAt
        })
        console.log("Finished creating feed item")
    })

    res.end()
}