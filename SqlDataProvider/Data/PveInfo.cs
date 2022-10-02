using System.Collections.Generic;

namespace SqlDataProvider.Data
{
    public class PveInfo
    {
        public string AdviceTips { get; set; }

        public string BossFightNeedMoney { get; set; }

        public string Description { get; set; }

        public string EpicGameScript { get; set; }

        public string EpicTemplateIds { get; set; }

        public string HardGameScript { get; set; }

        public string HardTemplateIds { get; set; }

        public int ID { get; set; }

        public int LevelLimits { get; set; }

        public string Name { get; set; }

        public string NormalGameScript { get; set; }

        public string NormalTemplateIds { get; set; }

        public int Ordering { get; set; }

        public string Pic { get; set; }

        public string SimpleGameScript { get; set; }

        public string SimpleTemplateIds { get; set; }

        public string TerrorGameScript { get; set; }

        public string TerrorTemplateIds { get; set; }

        public int Type { get; set; }

        public string LastFloor { get; set; }

        public int GetPrice(int selectedLevel)
        {
            int Money = 1;
            string ListMoney = BossFightNeedMoney;
            string[] SplitMoney = ListMoney.Split('|');
            if (SplitMoney.Length > 0)
            {
                switch (selectedLevel)
                {
                    case 0:
                        {
                            Money = int.Parse(SplitMoney[0]);
                            break;
                        }
                    case 1:
                        {
                            Money = int.Parse(SplitMoney[1]);
                            break;
                        }
                    case 2:
                        {
                            Money = int.Parse(SplitMoney[2]);
                            break;
                        }
                    case 3:
                        {
                            Money = int.Parse(SplitMoney[3]);
                            break;
                        }
                    case 4:
                        {
                            Money = int.Parse(SplitMoney[4]);
                            break;
                        }
                }
            }
            return Money;
        }
    }
}
