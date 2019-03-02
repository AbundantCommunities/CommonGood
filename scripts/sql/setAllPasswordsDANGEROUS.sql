/*
On your development machine it can help to force the login password of all users to 'shh;
*/

UPDATE person SET hashed_password =
'PBKDF2WithHmacSHA512|75000|64|256|o6auh3NPvmO/E5uLDV2AGxyDj7J6pBtc+kFrAUVt8QbKc40sx8w9/qpnh3x1V1HxgHhNXCrpuPmADqQiY8DX5w==|QK1tbv8gYSgcq6zddVFHI6XaVYKb5K9SAGuC4jHuOes=';
