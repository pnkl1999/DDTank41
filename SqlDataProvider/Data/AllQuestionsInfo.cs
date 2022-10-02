using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class AllQuestionsInfo
    {
        public int QuestionCatalogID { get; set; }
        public int QuestionID { get; set; }
        public string QuestionContent { get; set; }
        public string Option1 { get; set; }
        public string Option2 { get; set; }
        public string Option3 { get; set; }
        public string Option4 { get; set; }
    }
}
