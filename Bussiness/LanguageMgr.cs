using System;
using System.Text;
using System.IO;
using System.Collections;
using System.Reflection;
using log4net;
using System.Configuration;
using System.Threading;
using System.Xml.Linq;
using System.Collections.Generic;

namespace Bussiness
{
    public class LanguageMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Hashtable LangsSentences = new Hashtable();

        private static string LanguageFile
        {
            get
            {
                return ConfigurationManager.AppSettings["LanguagePath"];
            }
        }
        public static bool Setup(string path)
        {
            return Reload(path);
        }

        public static bool Reload(string path)
        {
            try
            {
                Hashtable temp = LoadLanguage(path);

                if (temp.Count > 0)
                {
                    Interlocked.Exchange(ref LangsSentences, temp);
                    return true;
                }
            }
            catch (Exception ex)
            {
                log.Error("Load language file error:", ex);
            }
            //finally
            //{
            //    log.WarnFormat("LangsSentences.Count: {0}", LangsSentences.Count);
            //    log.WarnFormat("LangsSentences: {0}", LangsSentences["PVPGame.SendGameOVer.SameIp"]);
            //}
            return false;
        }


        private static Hashtable LoadLanguage(string path)
        {
            Hashtable list = new Hashtable();

            string filePath = path + LanguageFile;
            if (!File.Exists(filePath))
            {
                log.Error("Language file : " + filePath + " not found !");
            }
            else
            {
                string[] lines = File.ReadAllLines(filePath, Encoding.UTF8);

                IList textList = new ArrayList(lines);
                foreach (string line in textList)
                {
                    if (line.StartsWith("#"))
                        continue;
                    if (line.IndexOf(':') == -1)
                        continue;

                    // Maybe use Regex here ?
                    string[] splitted = new string[2];
                    splitted[0] = line.Substring(0, line.IndexOf(':'));
                    splitted[1] = line.Substring(line.IndexOf(':') + 1);

                    splitted[1] = splitted[1].Replace("\t", "");
                    list[splitted[0]] = splitted[1];
                }
            }
            return list;
        }



        public static string GetTranslation(string translateId, params object[] args)
        {
            if (LangsSentences.ContainsKey(translateId))
            {

                string translated = (string)LangsSentences[translateId];

                try
                {
                    translated = string.Format(translated, args);
                }
                catch (Exception ex)
                {
                    log.Error("Parameters number error, ID: " + translateId + " (Arg count=" + args.Length + ")", ex);
                }
                return translated == null ? translateId : translated; ;
            }
            else
            {
                return translateId;
            }
        }
    }
}