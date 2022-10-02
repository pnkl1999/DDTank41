using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;

namespace Game.Server.GameServerScript.AI.Game
{
    public class GuluKingdomTerrorGame : APVEGameControl
    {
        public override void OnCreated()
        {
            Game.SetupMissions("1372,1373,1376,1377,1378");// 1375, chìa khóa
            Game.TotalMissionCount = 5;    
        }

        public override void OnPrepated()
        {
            //Game.SessionId = 0;
        }

        public override int CalculateScoreGrade(int score)
        {
            if(score > 800)
            {
                return 3;
            }
            else if(score > 725)
            {
                return 2;
            }
            else if(score > 650)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        public override void OnGameOverAllSession()
        {
        }
    }
}
