using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Resources;
using System.Text;
using System.Threading;
using System.Windows.Forms;

namespace ZGunLauncher
{
    public partial class Form1 : Form
    {
        private CultureInfo originalCulture;

        public Form1()
        {
            InitializeComponent();
            
        }

        public void IsProcessOpen(string processName)// processName is your e.exe process name pass as string example "e.exe"  
        {
            Process[] pname = Process.GetProcessesByName(System.IO.Path.GetFileNameWithoutExtension(processName));
            if (pname.Length > 0)
            {
                Process[] processes = Process.GetProcessesByName(processName);

                if (processes.Length > 0)
                {
                    foreach (Process process in processes)
                    {
                        process.Kill();
                    }
                }
            }
        }

        static void RunInternalExe(object tempName)
        {
            string exeName = tempName.ToString();
            //Get the current assembly
            Assembly assembly = Assembly.GetExecutingAssembly();

            //Get the assembly's root name
            string rootName = assembly.GetName().Name;

            //Get the resource stream
            Stream resourceStream = assembly.GetManifestResourceStream(rootName + "." + exeName);

            //Verify the internal exe exists
            if (resourceStream == null)
                return;

            //Read the raw bytes of the resource
            byte[] resourcesBuffer = new byte[resourceStream.Length];

            resourceStream.Read(resourcesBuffer, 0, resourcesBuffer.Length);
            resourceStream.Close();
            string pathName = Path.GetRandomFileName() + ".exe";
            try
            {
                using (FileStream exeFile = new FileStream(Path.Combine(Path.GetTempPath(), exeName), FileMode.Create))
                {
                    exeFile.Write(resourcesBuffer, 0, resourcesBuffer.Length);
                }

                Process.Start(Path.Combine(Path.GetTempPath(), exeName));
            }
            catch(Exception ex)
            {
                if(File.Exists(Path.Combine(Path.GetTempPath(), exeName)))//nguoi dung load nhieu form
                    Process.Start(Path.Combine(Path.GetTempPath(), exeName));
                else
                {
                    MessageBox.Show("Không thể khởi tạo tài nguyên");
                }
            }
            
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            IsProcessOpen("Gun321.Client.exe");
            Thread t = new Thread(new ParameterizedThreadStart(RunInternalExe));
            t.Start("Gun321.Client.exe");
            this.Close();
        }
    }
}
