using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Collections;
using System.IO;
using System.Text;

namespace Tank.Request.Illegalcharacters
{
    public class FileSystem
    {
        public ArrayList contentList = new ArrayList();                 //用于记录文件内容的ArrayList对象

        private FileSystemWatcher fileWatcher = new FileSystemWatcher();       //用于监控文件系统的检测者

        private string filePath = string.Empty;
        private string fileDirectory = string.Empty;
        private string fileType = string.Empty;


        public FileSystem(string Path, string Directory, string Type)
        {
            //
            // TODO: Add constructor logic here
            //
            initContent(Path);                          //初始化内容
            initFileWatcher(Directory, Type);       //初始化检查者
        }


        private void initContent(string Path)
        {
            //将文本内容记录到ArrayList对象中
            if (File.Exists(Path))
            {
                this.filePath = Path;
                StreamReader sr = new StreamReader(Path, Encoding.GetEncoding("GB2312"));
                string str = "";

                if (contentList.Count > 0)
                {
                    contentList.Clear();
                }
                while (str != null)
                {
                    str = sr.ReadLine();
                    if (!string.IsNullOrEmpty(str))
                    {
                        contentList.Add(str);
                    }

                }
                if (str == null)
                {
                    sr.Close();
                }

            }
        }

        private void initFileWatcher(string directory, string type)
        {

            if (Directory.Exists(directory))
            {
                this.fileDirectory = directory;
                this.fileType = type;
                //fileWatcher = new FileSystemWatcher(directory, type);
                fileWatcher.Path = directory;
                fileWatcher.Filter = type;
                //设置属性
                fileWatcher.NotifyFilter = NotifyFilters.LastAccess | NotifyFilters.LastWrite | NotifyFilters.FileName;
                fileWatcher.EnableRaisingEvents = true;
                fileWatcher.Changed += new FileSystemEventHandler(OnChanged);
                fileWatcher.Renamed += new RenamedEventHandler(OnRenamed);
            }




        }


        public bool checkIllegalChar(string strRegName)
        {
            bool flag = false;

            if (!string.IsNullOrEmpty(strRegName))
            {

                flag = checkChar(strRegName);

            }


            return flag;
        }

        private bool checkChar(string strRegName)
        {
            bool flag = false;
            foreach (string strLine in contentList)
            {
                //校验非法字符
                if (!strLine.StartsWith("GM"))
                {
                    foreach (char charl in strLine)
                    {
                        if (strRegName.Contains(charl.ToString()) && charl.ToString() != " ")
                        {
                            flag = true;
                            break;
                        }

                    }
                    if (flag)
                    {
                        break;
                    }
                }
                else
                {
                    //校验非法词组
                    string[] keyword = strLine.Split('|');
                    foreach (string key in keyword)
                    {
                        if (strRegName.Contains(key))
                        {
                            flag = true;
                            break;
                        }
                    }
                    if (flag)
                    {
                        break;
                    }


                }
            }

            return flag;
        }


        private void OnChanged(object source, FileSystemEventArgs e)
        {
            UpdataContent();
        }


        private void UpdataContent()
        {
            //重载文件内容
            initContent(filePath);

        }

        private static void OnRenamed(object source, RenamedEventArgs e)
        {
            //换文件名字
        }
    }
}
