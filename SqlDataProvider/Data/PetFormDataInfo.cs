using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class PetFormDataInfo
    {
        public string Appearance { get; set; }
        public int DamageReduce { get; set; }
        public int HeathUp { get; set; }
        public string Name { get; set; }
        public string Resource { get; set; }
        public int TemplateID { get; set; }
    }
}