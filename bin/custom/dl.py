import re
import sys
import subprocess
from urllib.parse import urlparse

# 检查 URL 是否为 GitHub 链接
def is_github_url(url):
    parsed = urlparse(url)
    return "github.com" in parsed.netloc or "githubusercontent.com" in parsed.netloc

# 将 raw.githubusercontent.com 链接转换为 github.com 链接
def normalize_github_url(url):
    # 处理 raw.githubusercontent.com 链接
    # 格式: https://raw.githubusercontent.com/user/repo/branch/path/to/file
    # 转换为: https://github.com/user/repo/raw/branch/path/to/file
    if "raw.githubusercontent.com" in url:
        match = re.match(r'https?://raw\.githubusercontent\.com/([^/]+)/([^/]+)/([^/]+)/(.*)', url)
        if match:
            user, repo, branch, file_path = match.groups()
            return f"https://github.com/{user}/{repo}/raw/{branch}/{file_path}"
    return url

# 将非 GitHub 链接转换为 GitHub 文件链接
def convert_to_github_url(url):
    # 这里只是一个简单的转换示例，假设输入的是一个包含文件名的下载链接
    match = re.match(r'(https?://[^/]+/.*?)(/raw/.*?)?', url)
    if match:
        github_url = match.group(1) + "/raw/main" + match.group(2) if match.group(2) else "/raw/main"
        return github_url
    else:
        raise ValueError("无法从给定链接生成 GitHub 原始链接")

# 根据 GitHub 链接生成 CDN 下载链接
def generate_cdn_url(github_url):
    # 构建 GitHub CDN 下载链接
    cdn_domains = [
        "gh.nxnow.top/https://github.com",
        "gh.zwy.one/https://github.com",
        "ghfast.top/https://github.com",
        "ghproxy.1888866.xyz/https://github.com",
        "ghproxy.cfd/https://github.com",
        "ghproxy.cxkpro.top/https://github.com",
        "ghproxy.net/https://github.com",
        "git.yylx.win/https://github.com",
        "github.boki.moe/https://github.com",
        "github.eo.bian666.cf/https://github.com",
        "github.limoruirui.com/https://github.com",
        "github.tbedu.top/https://github.com",
        "gitproxy.mrhjx.cn/https://github.com",
        "hub.gitmirror.com/https://github.com",
        "raw.ihtw.moe/github.com",
        "testingcf.jsdelivr.net/gh",
        "wget.la/https://github.com",
        "xget.xi-xu.me/gh",
        # 以下源 请求有报错
        "cdn.jsdelivr.net/gh",
        "cdn.gh-proxy.org/https://github.com",
        "rapidgit.jjda.de5.net/https://github.com",
        "gh.llkk.cc/https://github.com",
        "ghp.keleyaa.com/https://github.com",
        "ghpxy.hwinzniej.top/https://github.com",
        "ghfile.geekertao.top/https://github.com",
        "github.ednovas.xyz/https://github.com",
    ]

    cdn_domains = cdn_domains[:10]
    urls = []
    # 提取 repo 和路径部分
    parsed = urlparse(github_url)
    path = parsed.path
    # 处理 /raw/branch/xxx 的情况
    if "/raw/" in path:
        # 提取分支名和文件路径
        parts = path.split("/raw/", 1)
        repo_path = parts[0]
        remaining = parts[1].split("/", 1)
        branch = remaining[0] if len(remaining) > 0 else "main"
        file_path = remaining[1] if len(remaining) > 1 else ""

        for domain in cdn_domains:
            if domain.endswith("/gh"):
                # jsdelivr 格式
                urls.append(f"https://{domain}{repo_path}@{branch}/{file_path}")
            elif "github.com" in domain:
                # ghproxy 等格式
                urls.append(f"https://{domain}{repo_path}/raw/{branch}/{file_path}")
            elif "github" in domain:
                # 其他格式
                urls.append(f"https://{domain}{repo_path}/raw/{branch}/{file_path}")
            else:
                urls.append(f"https://{domain}{repo_path}/raw/{branch}/{file_path}")
    else:
        # 默认直接替换
        for domain in cdn_domains:
            urls.append(github_url.replace("github.com", domain))
    return urls

# 拼接 aria2c 下载命令并执行下载
def download_with_aria2c(cdn_urls, download_dir):
    # 支持多个 URL 同时下载，每个 URL 单独作为参数
    command = ["aria2c", "-d", download_dir] + cdn_urls
    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"下载失败: {e}")

# 主函数
def main():
    # 获取传入的链接
    input_url = sys.argv[1] if len(sys.argv) > 1 else input("请输入 GitHub 链接或文件链接：")
    download_dir = sys.argv[2] if len(sys.argv) > 2 else '.'

    if not is_github_url(input_url):
        print("输入的链接不是 GitHub 链接，正在尝试转换...")
        try:
            github_url = convert_to_github_url(input_url)
            print(f"转换后的 GitHub 链接: {github_url}")
        except ValueError as e:
            print(f"错误: {e}")
            return
    else:
        # 先规范化 URL（处理 raw.githubusercontent.com）
        github_url = normalize_github_url(input_url)
        print(f"输入的 GitHub 链接: {github_url}")

    cdn_urls = generate_cdn_url(github_url)
    print(f"生成的 CDN 下载链接: {cdn_urls[0]}")

    # 执行下载
    print(f"开始下载... 下载目录:{download_dir}")
    download_with_aria2c(cdn_urls, download_dir)

if __name__ == "__main__":
    main()
