using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class TeamLevelList
    {
        public int Level { get; set; }
        public int MaxPlayerNum { get; set; }
        public int NeedActive { get; set; }
        public int BuffParam { get; set; }
        public int BuffTwoParam { get; set; }
    }
}
