using Helpers;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

namespace Tank.Data
{
    public class AllQuestionsMgr
    {
        private static Dictionary<int, AllQuestionsInfo> m_allQuestionss = new Dictionary<int, AllQuestionsInfo>();

        public static bool Init() => AllQuestionsMgr.ReLoad();

        public static bool ReLoad()
        {
            try
            {
                Dictionary<int, AllQuestionsInfo> dictionary = AllQuestionsMgr.LoadFromDatabase();
                if (dictionary.Values.Count > 0)
                {
                    Interlocked.Exchange<Dictionary<int, AllQuestionsInfo>>(ref AllQuestionsMgr.m_allQuestionss, dictionary);
                    return true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("AllQuestionsMgr init error:" + ex.ToString());
            }
            return false;
        }

        private static Dictionary<int, AllQuestionsInfo> LoadFromDatabase()
        {
            Dictionary<int, AllQuestionsInfo> dictionary = new Dictionary<int, AllQuestionsInfo>();
            using (ProduceBussiness produceBussiness = new ProduceBussiness())
            {
                foreach (AllQuestionsInfo allAllQuestion in produceBussiness.GetAllAllQuestions())
                {
                    if (!dictionary.ContainsKey(allAllQuestion.QuestionID))
                        dictionary.Add(allAllQuestion.QuestionID, allAllQuestion);
                }
            }
            return dictionary;
        }

        public static List<AllQuestionsInfo> GetAllAllQuestions()
        {
            if (AllQuestionsMgr.m_allQuestionss.Count == 0)
                AllQuestionsMgr.Init();
            return AllQuestionsMgr.m_allQuestionss.Values.ToList<AllQuestionsInfo>();
        }

        public static AllQuestionsInfo FindAllQuestions(int id)
        {
            if (AllQuestionsMgr.m_allQuestionss.Count == 0)
                AllQuestionsMgr.Init();
            return AllQuestionsMgr.m_allQuestionss.ContainsKey(id) ? AllQuestionsMgr.m_allQuestionss[id] : (AllQuestionsInfo)null;
        }
    }
}
