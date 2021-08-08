module.exports = async function(req, res) {
    console.log("Showing home page...")
    const userId = req.session.userId
    
    const allPosts = []

    const feedItems = await FeedItem.find({user: userId})
        .sort('postCreatedAt DESC')
        .populate('post')
        .populate('postOwner')

    for (let i = 0; i < feedItems.length; i++) {
        const fi = feedItems[i]
        if (fi.post) {
            fi.post.user = fi.postOwner
            if (fi.postOwner.id == userId) {
                fi.post.user.isEditable = true
            }
            const hasLiked = await Like.findOne({ post: fi.post.id, user: userId })
            fi.post.hasLiked = hasLiked ? true : false
            allPosts.push(fi.post)
        } 
    }

    if (req.wantsJSON) {
        return res.send(allPosts)
    }

    const sanitizedPosts = JSON.parse(JSON.stringify(allPosts))
    
    res.view('pages/post/home', {
        allPosts: sanitizedPosts,
        layout: 'layouts/nav-layout'
    })
}