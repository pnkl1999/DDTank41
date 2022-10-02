using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
    public class EngraveSetElementInfo
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int SetId { get; set; }
        public int SkillId { get; set; }
        public string Explain { get; set; }
        public int Demand { get; set; }
        public string Attribute { get; set; }

        public List<MarkProDataInfo> AttributeList
        {
            get
            {
                List<MarkProDataInfo> datas = new List<MarkProDataInfo>();

                if(Attribute != "0")
                {
                    string[] attStrArr = Attribute.Split(',');

                    foreach(string attStr in attStrArr)
                    {
                        string[] attStrFinalArr = attStr.Split('|');
                        MarkProDataInfo temp = new MarkProDataInfo();
                        temp.type = int.Parse(attStrFinalArr[0]);
                        temp.value = int.Parse(attStrFinalArr[1]);
                        temp.attachValue = int.Parse(attStrFinalArr[2]);
                        datas.Add(temp);
                    }
                }

                return datas;
            }
        }
    }
}
