using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic.Effects;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class DCSM40016Boss : ABrain
    {
        private int m_attackTurn = 0;

        private int npcID = 5322;

        private int npcID2 = 5323;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;

        private PhysicalObj moive;

        private PhysicalObj front;

        private PhysicalObj wallLeft = null;

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[] {
            "Trận động đất, bản thân mình! ! <br/> bạn vui lòng Ay giúp đỡ",

            "Hạ vũ khí xuống!",

            "Xem nếu bạn có thể đủ khả năng, một số ít!！"
        };

        private static string[] ShootChat = new string[]{
             "Cho bạn biết những gì một cú sút vết nứt!",

             "Gửi cho bạn một quả bóng - bạn phải chọn Vâng",

             "Nhóm của bạn của những người dân thường ngu dốt và thấp"
        };

        private static string[] ShootedChat = new string[]{
           "Ah ~ ~ Tại sao bạn tấn công? <br/> tôi đang làm gì?",

            "Oh ~ ~ nó thực sự đau khổ! Tại sao tôi phải chiến đấu? <br/> tôi phải chiến đấu ..."

        };

        private static string[] AddBooldChat = new string[]{
            "Xoắn ah xoay ~ <br/>xoắn ah xoay ~ ~ ~",

            "~ Hallelujah <br/>Luyaluya ~ ~ ~",

            "Yeah Yeah Yeah, <br/> để thoải mái!"

        };

        private static string[] KillAttackChat = new string[]{
            "Con rồng trong thế giới! !"
        };

        #endregion

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 0 && player.X < 0)
                {
                    int dis = (int)Body.Distance(player.X, player.Y);
                    if (dis > maxdis)
                    {
                        maxdis = dis;
                    }
                    result = true;
                }
            }

            if (result)
            {
                KillAttack(0, 0);
                return;
            }

            if (Body.State == 1)
                return;

            if (m_attackTurn == 0)
            {
                CallBell();//call bell
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                BeatE();// and attack niutou
                m_attackTurn++;
            }
            //else  if (m_attackTurn == 2)
            //{
            //call box
            //    m_attackTurn++;
            //}
            //else if (m_attackTurn == 3)
            //{
            //call effect 2
            //    m_attackTurn++;
            //}
            else
            {
                BlackAttack(); // and attack niutou
                m_attackTurn = 0;
            }
        }

        private void CallBell()
        {
            Body.PlayMovie("beatB", 3300, 0);
        }

        private void BlackAttack()
        {
            Body.PlayMovie("beatA", 0, 3000);
            moive = ((PVEGame)Game).Createlayer(Body.X, Body.Y, "top", "asset.game.4.heip", "out", 2, 1);
            Body.CallFuction(AllAttack, 2500);
        }
        private void AllAttack()
        {
            Body.CurrentDamagePlus = 2.5f;
            Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "cry", 500, null);
            Body.CallFuction(RemoveMove, 0);
        }

        private void RemoveMove()
        {
            if (moive != null)
            {
                Game.RemovePhysicalObj(moive, true);
                moive = null;
            }
            if (front != null)
            {
                Game.RemovePhysicalObj(front, true);
                front = null;
            }
        }


        private void BeatE()
        {
            Player target = Game.FindRandomPlayer();
            if (target == null)
                return;
            int mtX = target.X;
            int mtY = target.Y - 95;
            Body.MoveTo(mtX, mtY, "fly", 1000, "", 16, PersonalAttack);
        }
        private void PersonalAttack()
        {
            Body.CurrentDamagePlus = 5.5f;
            Body.PlayMovie("beatE", 3500, 0);
            Player target = Game.FindRandomPlayer();
            if (target == null)
                return;
            Body.RangeAttacking(target.X - 50, target.X + 50, "cry", 5000, null);
            Body.CallFuction(Run, 5000);
        }
        private void Run()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            Body.MoveTo(850, 470, "fly", 1000, "", 16, ChangeDirection);
        }
        private void ChangeDirection()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
        }
        private void CallHopquaidi()
        {
            Body.CurrentDamagePlus = 0.8f;

            int index = Game.Random.Next(0, ShootChat.Length);
            Body.Say(ShootChat[index], 1, 0);
            int dis = Game.Random.Next(400, 1300);

            Player target = Game.FindRandomPlayer();
            if (target == null)
                return;
            int mtX = target.X;
            int mtY = target.Y - 150;
            Body.MoveTo(mtX, mtY, "fly", 3500, "", 16, new LivingCallBack(CallHopquaidi2));

            Body.PlayMovie("beatD", 3300, 2000);
        }

        private void BeatDame()
        {
            Player target = Game.FindRandomPlayer();
            if (target != null)
                return;
            int mtX = target.X;
            int mtY = target.Y - 150;
            Body.MoveTo(mtX, mtY, "fly", 3500, "", 16, new LivingCallBack(GoBeatDame));
        }

        private void GoBeatDame()
        {
            int index = Game.Random.Next(0, AddBooldChat.Length);
            Body.Say(AddBooldChat[index], 1, 0);
            Body.Direction = Game.FindlivingbyDir(Body);
            Body.SyncAtTime = true;
            Body.PlayMovie("beatE", 3300, 5000);
            Body.RangeAttacking(Body.X - 100, Body.X + 100, "cry", 5000, null);
        }

        private void KillAttack(int fx, int tx)
        {
            Body.CurrentDamagePlus = 10;
            int index = Game.Random.Next(0, KillAttackChat.Length);
            Body.Say(KillAttackChat[index], 1, 1000);
            Body.PlayMovie("beat", 3000, 0);
            Body.RangeAttacking(fx, tx, "cry", 4000, null);
        }



        private void CallHopquaidi2()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            int dis = Game.Random.Next(700, 1300);
            Body.SetXY(Body.X, 600);
            ((SimpleBoss)Body).CreateChild(npcID2, dis, 900, 1000, 1, -1);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
        
    }
}
