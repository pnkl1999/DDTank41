using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class MountDrawTemplateInfo
    {
        public int ID { get; set; }
        public int TemplateId { get; set; }
        public int AddHurt { get; set; }
        public int AddGuard { get; set; }
        public int MagicAttack { get; set; }
        public int MagicDefence { get; set; }
        public int AddBlood { get; set; }
        public string Name { get; set; }
    }
}