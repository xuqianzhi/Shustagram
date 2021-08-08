module.exports = async function(req, res) {
    const allUsers = await User.find({});
    // console.log("all users found are: ", allUsers)
    res.view('pages/post/populate', {
        allUsers
    })
}