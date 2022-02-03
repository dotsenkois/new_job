output "alb_dns_name" {
  value = aws_lb.examle.dns_name
  description = "The domain name of load balncer"
}

