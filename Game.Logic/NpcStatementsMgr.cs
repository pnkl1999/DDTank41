using log4net;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

namespace Game.Logic
{
    public class NpcStatementsMgr
    {
        private static string filePath;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static List<string> m_npcstatement = new List<string>();

        private static Random random;

        public static string GetRandomStatement()
        {
			int num = random.Next(0, m_npcstatement.Count);
			return m_npcstatement[num];
        }

        public static string GetStatement(int index)
        {
			if (index < 0 || index > m_npcstatement.Count)
			{
				return null;
			}
			return m_npcstatement[index];
        }

        public static bool Init()
        {
			filePath = Directory.GetCurrentDirectory() + "\\ai\\npc\\npc_statements.txt";
			random = new Random();
			return ReLoad();
        }

        public static string[] RandomStatement(int count)
        {
			string[] strArray = new string[count];
			int[] numArray = RandomStatementIndexs(count);
			for (int i = 0; i < count; i++)
			{
				int num2 = numArray[i];
				strArray[i] = m_npcstatement[num2];
			}
			return strArray;
        }

        public static int[] RandomStatementIndexs(int count)
        {
			int[] source = new int[count];
			int index = 0;
			while (index < count)
			{
				int num2 = random.Next(0, m_npcstatement.Count);
				if (!source.Contains(num2))
				{
					source[index] = num2;
					index++;
				}
			}
			return source;
        }

        public static bool ReLoad()
        {
			try
			{
				string item = string.Empty;
				StreamReader reader = new StreamReader(filePath, Encoding.Default);
				while (!string.IsNullOrEmpty(item = reader.ReadLine()))
				{
					m_npcstatement.Add(item);
				}
				return true;
			}
			catch (Exception exception)
			{
				log.Error("NpcStatementsMgr.Reload()", exception);
				return false;
			}
        }
    }
}
