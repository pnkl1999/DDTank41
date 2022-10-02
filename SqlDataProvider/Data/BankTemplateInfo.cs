using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class BankTemplateInfo
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public int InterestRate { get; set; }
        public int MinAmount { get; set; }
        public int Multiple { get; set; }
        public int Consume { get; set; }
        public int DeadLine { get; set; }
    }
}
