# S3 static website hosting lab: Dec 6th 2025
---------------------------------------------

## ClickOps

1) Open console and go to S3 dashboard
2) get static assets
3) create bucket
4) upload assets
5) make it publically accessible 
  - remove the "block all public access" setting
  - add a bucket policy
6) verify public access
7) enable static hosting (we arent using object endpoints)
  - set the index and error pages
  
  
## Terraform

### Config that *is not* default:
  - added a bucket policy
  - disable "block all public access"
  - enable static website hosting
  - uploaded objects


###  Resource to create: 
  - s3 bucket
  - s3 object (upload them to the aforementioned bucket)
  - public access block (we are disabling this)
  - make a policy (explain jsonencode())
  - static website config
  
###  Desired output:
  - static website url 
  - bucket name 
  - arn 
  
### policy
```bash
policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicAccess"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "<resource>"
      }
    ]
  })
  ```
  

  ### content types
  https://udn.realityripple.com/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
  

