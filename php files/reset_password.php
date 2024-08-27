<?php
include 'dbconnection.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $con = dbconnection();
    $emailOrUsername = $_POST['emailOrUsername'];
    $newPassword = $_POST['newPassword'];

    $query = "UPDATE users SET upassword='$newPassword' WHERE uname='$emailOrUsername' OR uemail='$emailOrUsername'";
    if (mysqli_query($con, $query)) {
        echo json_encode(["status" => "success", "message" => "Password reset successful"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Password reset failed"]);
    }

    mysqli_close($con);
}
?>
