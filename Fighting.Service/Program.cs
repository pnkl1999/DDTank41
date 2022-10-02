using Fighting.Service.action;
using System;
using System.Collections;
using System.IO;
using System.Threading;

namespace Fighting.Service
{
    internal class Program
    {
        private static ArrayList _actions = new ArrayList();

        [MTAThread]
		private static void Main(string[] args)
        {
			AppDomain.CurrentDomain.SetupInformation.PrivateBinPath = "." + Path.DirectorySeparatorChar + "lib";
			Thread.CurrentThread.Name = "MAIN";
			RegisterActions();
			if (args.Length == 0)
			{
				args = new string[1]
				{
					"--start"
				};
			}
			string actionName;
			Hashtable parameters;
			try
			{
				ParseParameters(args, out actionName, out parameters);
			}
			catch (ArgumentException ex)
			{
				Console.WriteLine(ex.Message);
				return;
			}
			IAction action = GetAction(actionName);
			if (action != null)
			{
				action.OnAction(parameters);
			}
			else
			{
				ShowSyntax();
			}
        }

        private static void RegisterActions()
        {
			RegisterAction(new ConsoleStart());
        }

        private static void RegisterAction(IAction action)
        {
			if (action == null)
			{
				throw new ArgumentException("Action can't be bull", "actioni");
			}
			_actions.Add(action);
        }

        public static void ShowSyntax()
        {
			Console.WriteLine("Syntax: RoadServer.exe {action} [param1=value1] [param2=value2] ...");
			Console.WriteLine("Possible actions:");
			foreach (IAction action in _actions)
			{
				if (action.Syntax != null && action.Description != null)
				{
					Console.WriteLine(string.Format("{0,-20}\t{1}", action.Syntax, action.Description));
				}
			}
        }

        private static IAction GetAction(string name)
        {
			foreach (IAction action in _actions)
			{
				if (action.Name.Equals(name))
				{
					return action;
				}
			}
			return null;
        }

        private static void ParseParameters(string[] args, out string actionName, out Hashtable parameters)
        {
			parameters = new Hashtable();
			actionName = null;
			if (!args[0].StartsWith("--"))
			{
				throw new ArgumentException("First argument must be the action");
			}
			actionName = args[0];
			if (args.Length == 1)
			{
				return;
			}
			for (int i = 1; i < args.Length; i++)
			{
				string arg = args[i];
				if (arg.StartsWith("--"))
				{
					throw new ArgumentException("At least two actions given and only one action allowed!");
				}
				if (!arg.StartsWith("-"))
				{
					continue;
				}
				int valueIdx = arg.IndexOf('=');
				if (valueIdx == -1)
				{
					parameters.Add(arg, "");
					continue;
				}
				string argName = arg.Substring(0, valueIdx);
				string argValue = "";
				if (valueIdx + 1 < arg.Length)
				{
					argValue = arg.Substring(valueIdx + 1);
				}
				parameters.Add(argName, argValue);
			}
        }
    }
}
