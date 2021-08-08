module.exports = {


  friendlyName: 'Upload file',


  description: '',


  inputs: {
    file: {
      type: 'ref',
      description: 'The file I want to upload to AWS S3'
    }
  },


  exits: {

    success: {
      description: 'All done.',
    },
    badUpload: {
      description: 'Upload failed.'
    }
  },


  fn: async function (inputs, exits) {
    console.log("Trying to upload file with helper method..")

    const file = inputs.file

    // perform file upload
    const options =
    { // This is the usual stuff
        adapter: require('skipper-better-s3')
        , key: process.env.S3_KEY
        , secret: process.env.S3_SECRET
        , bucket: 'shustagram-images'
        , s3params:
        {
            ACL: 'public-read'
        }
        // And while we are at it, let's monitor the progress of this upload
        , onProgress: progress => sails.log.verbose('Upload progress:', progress)
    }

    file.upload(options, async (err, files) => {
        if (err) { 
          throw('uploadFailed')
        }

        const fileUrl = files[0].extra.Location
        return exits.success(fileUrl)
    })
  }


};

