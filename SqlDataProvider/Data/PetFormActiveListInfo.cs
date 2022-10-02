using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class PetFormActiveListInfo
    {
        public bool IsFollow { get; set; }
        public int TemplateID { get; set; }
        public DateTime validDate { get; set; }
    }
}
