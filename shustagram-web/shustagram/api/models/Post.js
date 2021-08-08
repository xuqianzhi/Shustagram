module.exports = {

    customToJSON: function() {
        const moment = sails.moment
        this.fromNow = moment(this.createdAt).fromNow()
        return this
    },

    attributes: {
        text: {
            type: 'string', required: true
        },

        imageUrl: {
            type: 'string',
            defaultsTo: ''
        },

        user: {
            model: 'user'
        },

        numLikes: {
            type: 'number', defaultsTo: 0
        },
    }
}