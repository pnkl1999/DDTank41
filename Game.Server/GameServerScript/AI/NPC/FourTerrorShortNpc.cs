using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;
using Game.Logic.Effects;
using Game.Server.GameServerScript.AI.Messions;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class FourTerrorShortNpc : ABrain
    {
        private string[] NormalSay =
        {
            "Thằng khốn nạn nào quăng mình ra đây thế này?",
            "Đây là đâu? Sao nóng thế?",
            "Tại sao mình lại ở đây nhỉ?",
            "Chuyện gì đang xảy ra vậy?",
            "Thật không thể hiểu nổi!"
        };

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;

            if (Game.Random.Next(100) < 50)
            {
                int place = Game.Random.Next(0, NormalSay.Length);
                Body.Say(NormalSay[place], 1, 0);
            }
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();

            SimpleBoss enemy = (((PVEGame)Game).MissionAI as DCT4301).Helper;

            int randX = Game.Random.Next(100, 200);

            Body.MoveTo(enemy.X + randX, enemy.Y, "walk", 1500, 3);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
