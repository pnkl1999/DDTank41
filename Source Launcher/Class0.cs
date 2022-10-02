using System;
using System.Reflection;
using System.Windows.Forms;
using Launcher.EmbedAssemblies;
using Launcher.Forms;
using Launcher.Properties;
using Launcher.Statics;
using Properties;

namespace Launcher
{
	class Program
	{
		static void Main(string[] args)
		{
            //DDTStaticFunc.IsDebug = true;//turn off is debug for production 

            if (args != null && ((Array)args).Length >= 3)
			{
				DDTStaticFunc.SetUrl((string)((object[])args)[0], (string)((object[])args)[1], (string)((object[])args)[2]);
				if (((Array)args).Length == 4)
				{
					DDTStaticFunc.IsDebug = (string)((object[])args)[3] == Resources.MAC_Address;
				}
			}
			DDTStaticFunc.Init();

			EmbeddedAssembly.Load("Launcher.EmbedAssemblies.Assemblies.CircularProgressBar.dll", "CircularProgressBar.dll");
			EmbeddedAssembly.Load("Launcher.EmbedAssemblies.Assemblies.WinFormAnimation.dll", "WinFormAnimation.dll");
			EmbeddedAssembly.Load("Launcher.EmbedAssemblies.Assemblies.zlib.net.dll", "zlib.net.dll");
			AppDomain.CurrentDomain.AssemblyResolve += smethod_0;
			Application.EnableVisualStyles();
			Application.SetCompatibleTextRenderingDefault(defaultValue: false);
			Application.Run(new Login());
		}

		private static Assembly smethod_0(object object_0, ResolveEventArgs resolveEventArgs_0)
		{
			return EmbeddedAssembly.Get(resolveEventArgs_0.Name);
		}
	}
}