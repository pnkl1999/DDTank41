using log4net;
using Microsoft.CSharp;
using Microsoft.VisualBasic;
using System;
using System.CodeDom.Compiler;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

namespace Game.Server.Managers
{
    public class ScriptMgr
    {
        private static readonly ILog log;

        private static readonly Dictionary<string, Assembly> m_scripts;

        public static Assembly[] Scripts
        {
			get
			{
				lock (m_scripts)
				{
					return m_scripts.Values.ToArray();
				}
			}
        }

        static ScriptMgr()
        {
			log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			m_scripts = new Dictionary<string, Assembly>();
        }

        public static bool CompileScripts(bool compileVB, string path, string dllName, string[] asm_names)
        {
			if (!path.EndsWith("\\") && !path.EndsWith("/"))
			{
				path += "/";
			}
			ArrayList files = ParseDirectory(new DirectoryInfo(path), compileVB ? "*.vb" : "*.cs", deep: true);
			if (files.Count == 0)
			{
				return true;
			}
			if (File.Exists(dllName))
			{
				File.Delete(dllName);
			}
			CompilerResults res = null;
			try
			{
				CodeDomProvider compiler = null;
				compiler = (compileVB ? ((CodeDomProvider)new VBCodeProvider()) : ((CodeDomProvider)new CSharpCodeProvider()));
				CompilerParameters param = new CompilerParameters(asm_names, dllName, includeDebugInformation: true)
				{
					GenerateExecutable = false,
					GenerateInMemory = false,
					WarningLevel = 2,
					CompilerOptions = "/lib:."
				};
				string[] filepaths = new string[files.Count];
				for (int i = 0; i < files.Count; i++)
				{
					filepaths[i] = ((FileInfo)files[i]).FullName;
				}
				res = compiler.CompileAssemblyFromFile(param, filepaths);
				GC.Collect();
				if (res.Errors.HasErrors)
				{
					foreach (CompilerError err in res.Errors)
					{
						if (!err.IsWarning)
						{
							StringBuilder builder = new StringBuilder();
							builder.Append("   ");
							builder.Append(err.FileName);
							builder.Append(" Line:");
							builder.Append(err.Line);
							builder.Append(" Col:");
							builder.Append(err.Column);
							if (log.IsErrorEnabled)
							{
								log.Error("Script compilation failed because: ");
								log.Error(err.ErrorText);
								log.Error(builder.ToString());
							}
						}
					}
					return false;
				}
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("CompileScripts", e);
				}
			}
			if (res != null && !res.Errors.HasErrors)
			{
				InsertAssembly(res.CompiledAssembly);
			}
			return true;
        }

        public static object CreateInstance(string name)
        {
			Assembly[] scripts = Scripts;
			for (int i = 0; i < scripts.Length; i++)
			{
				Type t = scripts[i].GetType(name);
				if (t != null && t.IsClass)
				{
					return Activator.CreateInstance(t);
				}
			}
			return null;
        }

        public static Type[] GetDerivedClasses(Type baseType)
        {
			if (baseType == null)
			{
				return new Type[0];
			}
			ArrayList types = new ArrayList();
			foreach (Assembly asm in new ArrayList(Scripts))
			{
				Type[] typeArray = asm.GetTypes();
				foreach (Type t in typeArray)
				{
					if (t.IsClass && baseType.IsAssignableFrom(t))
					{
						types.Add(t);
					}
				}
			}
			return (Type[])types.ToArray(typeof(Type));
        }

        public static bool InsertAssembly(Assembly ass)
        {
			lock (m_scripts)
			{
				if (m_scripts.ContainsKey(ass.FullName))
				{
					return false;
				}
				m_scripts.Add(ass.FullName, ass);
				return true;
			}
        }

        private static ArrayList ParseDirectory(DirectoryInfo path, string filter, bool deep)
        {
			ArrayList files = new ArrayList();
			if (!path.Exists)
			{
				return files;
			}
			files.AddRange(path.GetFiles(filter));
			if (deep)
			{
				DirectoryInfo[] directories = path.GetDirectories();
				foreach (DirectoryInfo subdir in directories)
				{
					files.AddRange(ParseDirectory(subdir, filter, deep));
				}
			}
			return files;
        }

        public static bool RemoveAssembly(Assembly ass)
        {
			lock (m_scripts)
			{
				return m_scripts.Remove(ass.FullName);
			}
        }
    }
}
