module.exports = {
    attributes: {
        text: {
            type: 'string', required: true
        },

        post: {
            model: 'post', required: true,
        },

        user: {
            model: 'user', required: true,
        }
    }
}