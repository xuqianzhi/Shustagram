module.exports = {
    attributes: {
        post: {
            model: 'post'
        },

        postOwner: {
            model: 'user'
        },

        user: {
            model: 'user'
        },

        postCreatedAt: {
            type: 'number'
        },
    }
}