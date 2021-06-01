function curl_ip_address() {
  curl -sS ifconfig.me
}

function weather() {
  curl -sS "wttr.in/@$(curl_ip_address)"
}
