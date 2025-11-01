#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Get the IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Background the curl requests
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4 &> /tmp/local_ipv4 &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/placement/availability-zone &> /tmp/az &
curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/ &> /tmp/macid &
wait

macid=$(cat /tmp/macid)
local_ipv4=$(cat /tmp/local_ipv4)
az=$(cat /tmp/az)
vpc=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${macid}/vpc-id)

# Get hostname
hostname_value=$(hostname -f)

cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The algorithm demands I go to China</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: #1a1a1a;
            min-height: 100vh;
            padding: 40px 20px;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
        }
        
        h1 {
            color: #1a1a1a;
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-align: center;
        }
        
        h2 {
            color: #666666;
            font-size: 1.8rem;
            margin-bottom: 30px;
            text-align: center;
            font-weight: 600;
        }
        
        .image-gallery {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 40px 0;
        }
        
        .image-card {
            border: 2px solid #e5e5e5;
            border-radius: 12px;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .image-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .image-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            display: block;
        }
        
        .details {
            background: #f5f5f5;
            border: 2px solid #e5e5e5;
            border-radius: 12px;
            padding: 30px;
            margin-top: 30px;
        }
        
        .details h3 {
            color: #1a1a1a;
            font-size: 1.4rem;
            margin-bottom: 20px;
            border-bottom: 2px solid #666666;
            padding-bottom: 10px;
        }
        
        .detail-item {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px solid #e5e5e5;
        }
        
        .detail-item:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 600;
            color: #333333;
            min-width: 200px;
        }
        
        .detail-value {
            color: #1a1a1a;
            font-family: 'Courier New', monospace;
            background: white;
            padding: 4px 12px;
            border-radius: 6px;
            border: 1px solid #e5e5e5;
        }
        
        .instagram-section {
            margin-top: 40px;
            padding-top: 40px;
            border-top: 2px solid #e5e5e5;
        }
        
        .instagram-embed {
            display: flex;
            justify-content: center;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>The algorithm demands I go to China</h1>
        <h2>AWS Instance metadata too I guess</h2>
        
        <div class="image-gallery">
            <div class="image-card">
                <img src="https://scontent.cdninstagram.com/v/t51.82787-15/541573174_18341490049160023_438000474535646692_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=103&ig_cache_key=MzcxMjE0MDMxNjI0MzA0NTc0NQ%3D%3D.3-ccb1-7&ccb=1-7&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6InhwaWRzLjE0NDB4MTkyMC5zZHIuQzMifQ%3D%3D&_nc_ohc=06mMbG6XwxkQ7kNvwFPdS0I&_nc_oc=AdmElzxaaHPuMOXnua3m2JWtPioDUKdYGD8DiaDK3gyD0qk0s7ohXsZkgmoD2K69eLh0OCXhjVouHKVBpR0mTeEN&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.cdninstagram.com&_nc_gid=X4EF0fN1afheuQlrRkXpOQ&oh=00_Afjvl5a0F3sTPrORh6zjKaOfHJFvk0yQYrbt3PUifGu-Kw&oe=690C63E1" alt="Image 1">
            </div>
            <div class="image-card">
                <img src="https://scontent.cdninstagram.com/v/t51.75761-15/494927942_18266238721272669_4860080150418450671_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=105&ig_cache_key=MzYyNDM2MDk1NjM0MzU5MDY1Nw%3D%3D.3-ccb1-7&ccb=1-7&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6InhwaWRzLjExMjV4MTQwNS5zZHIuQzMifQ%3D%3D&_nc_ohc=AcaDVTKrFS8Q7kNvwEtzNMb&_nc_oc=AdlqeS2G0djGzeYgiBc57lYXOPDxaMZ1c_EyyuE84Dy3pU4RpeNQU1kox9ZoXmoquTwqlgZYE1elGU_rc7rAcfg_&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.cdninstagram.com&_nc_gid=PO61gioTD0bpwgv2hrnjJg&oh=00_AfhyPtkH5y3mX5GrjWc0mnlSN680tkH43pEKuLYj85OmWA&oe=690C4A3D" alt="Image 2">
            </div>
            <div class="image-card">
                <img src="https://scontent.cdninstagram.com/v/t51.75761-15/494359394_18031126136655340_3535636154567297169_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=105&ig_cache_key=MzYyMDg0MTEzODM1NTY0OTU5Mg%3D%3D.3-ccb1-7&ccb=1-7&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6InhwaWRzLjgyOHgxMDM1LnNkci5DMyJ9&_nc_ohc=GfLG5O2JU80Q7kNvwHAsAyS&_nc_oc=AdnIQllDoG4rFdmyDXz8Ukp83uVvSCpV1APxnlIgBearOZi490EiiQ8dfGq1jsGKIu6ye9jpJj3wYLC15juSY_H8&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.cdninstagram.com&_nc_gid=sxdp3l6DETl7T-Xc4pactA&oh=00_Afgel2NG4AmPSrb5bU-d6kaDu-CsL3ZyNaAlczv8d-5_IA&oe=690C63FB" alt="Image 3">
            </div>
        </div>
        
        <div class="details">
            <h3>Instance Information</h3>
            <div class="detail-item">
                <span class="detail-label">Instance Name:</span>
                <span class="detail-value">${hostname_value}</span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Private IP Address:</span>
                <span class="detail-value">${local_ipv4}</span>
            </div>
            <div class="detail-item">
                <span class="detail-label">Availability Zone:</span>
                <span class="detail-value">${az}</span>
            </div>
            <div class="detail-item">
                <span class="detail-label">VPC ID:</span>
                <span class="detail-value">${vpc}</span>
            </div>
        </div>
        
        <div class="instagram-section">
            <div class="instagram-embed">
                <blockquote class="instagram-media" data-instgrm-permalink="https://www.instagram.com/reel/DQgJJDMjt4A/?utm_source=ig_embed&utm_campaign=loading" data-instgrm-version="14" style=" background:#FFF; border:0; border-radius:3px; box-shadow:0 0 1px 0 rgba(0,0,0,0.5),0 1px 10px 0 rgba(0,0,0,0.15); margin: 1px; max-width:540px; min-width:326px; padding:0; width:99.375%; width:-webkit-calc(100% - 2px); width:calc(100% - 2px);"><div style="padding:16px;"> <a href="https://www.instagram.com/reel/DQgJJDMjt4A/?utm_source=ig_embed&utm_campaign=loading" style=" background:#FFFFFF; line-height:0; padding:0 0; text-align:center; text-decoration:none; width:100%;" target="_blank"> <div style=" display: flex; flex-direction: row; align-items: center;"> <div style="background-color: #F4F4F4; border-radius: 50%; flex-grow: 0; height: 40px; margin-right: 14px; width: 40px;"></div> <div style="display: flex; flex-direction: column; flex-grow: 1; justify-content: center;"> <div style=" background-color: #F4F4F4; border-radius: 4px; flex-grow: 0; height: 14px; margin-bottom: 6px; width: 100px;"></div> <div style=" background-color: #F4F4F4; border-radius: 4px; flex-grow: 0; height: 14px; width: 60px;"></div></div></div><div style="padding: 19% 0;"></div> <div style="display:block; height:50px; margin:0 auto 12px; width:50px;"><svg width="50px" height="50px" viewBox="0 0 60 60" version="1.1" xmlns="https://www.w3.org/2000/svg" xmlns:xlink="https://www.w3.org/1999/xlink"><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-511.000000, -20.000000)" fill="#000000"><g><path d="M556.869,30.41 C554.814,30.41 553.148,32.076 553.148,34.131 C553.148,36.186 554.814,37.852 556.869,37.852 C558.924,37.852 560.59,36.186 560.59,34.131 C560.59,32.076 558.924,30.41 556.869,30.41 M541,60.657 C535.114,60.657 530.342,55.887 530.342,50 C530.342,44.114 535.114,39.342 541,39.342 C546.887,39.342 551.658,44.114 551.658,50 C551.658,55.887 546.887,60.657 541,60.657 M541,33.886 C532.1,33.886 524.886,41.1 524.886,50 C524.886,58.899 532.1,66.113 541,66.113 C549.9,66.113 557.115,58.899 557.115,50 C557.115,41.1 549.9,33.886 541,33.886 M565.378,62.101 C565.244,65.022 564.756,66.606 564.346,67.663 C563.803,69.06 563.154,70.057 562.106,71.106 C561.058,72.155 560.06,72.803 558.662,73.347 C557.607,73.757 556.021,74.244 553.102,74.378 C549.944,74.521 548.997,74.552 541,74.552 C533.003,74.552 532.056,74.521 528.898,74.378 C525.979,74.244 524.393,73.757 523.338,73.347 C521.94,72.803 520.942,72.155 519.894,71.106 C518.846,70.057 518.197,69.06 517.654,67.663 C517.244,66.606 516.755,65.022 516.623,62.101 C516.479,58.943 516.448,57.996 516.448,50 C516.448,42.003 516.479,41.056 516.623,37.899 C516.755,34.978 517.244,33.391 517.654,32.338 C518.197,30.938 518.846,29.942 519.894,28.894 C520.942,27.846 521.94,27.196 523.338,26.654 C524.393,26.244 525.979,25.756 528.898,25.623 C532.057,25.479 533.004,25.448 541,25.448 C548.997,25.448 549.943,25.479 553.102,25.623 C556.021,25.756 557.607,26.244 558.662,26.654 C560.06,27.196 561.058,27.846 562.106,28.894 C563.154,29.942 563.803,30.938 564.346,32.338 C564.756,33.391 565.244,34.978 565.378,37.899 C565.522,41.056 565.552,42.003 565.552,50 C565.552,57.996 565.522,58.943 565.378,62.101 M570.82,37.631 C570.674,34.438 570.167,32.258 569.425,30.349 C568.659,28.377 567.633,26.702 565.965,25.035 C564.297,23.368 562.623,22.342 560.652,21.575 C558.743,20.834 556.562,20.326 553.369,20.18 C550.169,20.033 549.148,20 541,20 C532.853,20 531.831,20.033 528.631,20.18 C525.438,20.326 523.257,20.834 521.349,21.575 C519.376,22.342 517.703,23.368 516.035,25.035 C514.368,26.702 513.342,28.377 512.574,30.349 C511.834,32.258 511.326,34.438 511.181,37.631 C511.035,40.831 511,41.851 511,50 C511,58.147 511.035,59.17 511.181,62.369 C511.326,65.562 511.834,67.743 512.574,69.651 C513.342,71.625 514.368,73.296 516.035,74.965 C517.703,76.634 519.376,77.658 521.349,78.425 C523.257,79.167 525.438,79.673 528.631,79.82 C531.831,79.965 532.853,80.001 541,80.001 C549.148,80.001 550.169,79.965 553.369,79.82 C556.562,79.673 558.743,79.167 560.652,78.425 C562.623,77.658 564.297,76.634 565.965,74.965 C567.633,73.296 568.659,71.625 569.425,69.651 C570.167,67.743 570.674,65.562 570.82,62.369 C570.966,59.17 571,58.147 571,50 C571,41.851 570.966,40.831 570.82,37.631"></path></g></g></g></svg></div><div style="padding-top: 8px;"> <div style=" color:#3897f0; font-family:Arial,sans-serif; font-size:14px; font-style:normal; font-weight:550; line-height:18px;">View this post on Instagram</div></div><div style="padding: 12.5% 0;"></div> <div style="display: flex; flex-direction: row; margin-bottom: 14px; align-items: center;"><div> <div style="background-color: #F4F4F4; border-radius: 50%; height: 12.5px; width: 12.5px; transform: translateX(0px) translateY(7px);"></div> <div style="background-color: #F4F4F4; height: 12.5px; transform: rotate(-45deg) transla