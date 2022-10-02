using Game.Base.Packets;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

namespace Game.Logic.Cmd
{
    [GameCommand(2, "用户开炮")]
    public class FireCommand : ICommandHandler
    {
        public static List<string> aimUsers = new List<string> {
            //"vinhkosd",
            // "schwarz0112",
            // "schwarzer0112",
            // "baka9x",
            // "khanhlam",
            // "khanhlam11",
        };
    public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
            if (player.IsAttacking)
            {
                int x = packet.ReadInt();
                int y = packet.ReadInt();
                if (player.CheckShootPoint(x, y))
                {
                    int force = packet.ReadInt();
                    int angle = packet.ReadInt();
                    
                    float time_s = 1.0f;

                    List<Player> players = game.GetAllEnemyPlayers(player);
                    int realAngle = Math.Abs(angle);
                   
                    realAngle = realAngle > 90 && realAngle < 180 ? 180 - realAngle : realAngle;
                    realAngle = realAngle > 180 && realAngle < 270 ? -realAngle + 180 : realAngle;
                    realAngle = realAngle > 270 ? realAngle - 360 : realAngle;

                    if (realAngle < 35 && aimUsers.Contains(player.PlayerDetail.PlayerCharacter.UserName))
                    {
                        foreach (var p1 in players)
                        {
                            x = p1.X;
                            y = p1.Y;
                        }

                        if (Math.Abs(player.X - x) < 200)
                        {
                            time_s = 1.0f;
                        }
                        else if (Math.Abs(player.X - x) < 400)
                        {
                            time_s = 1.5f;
                        }
                        else if (Math.Abs(player.X - x) < 700)
                        {
                            time_s = 2.0f;
                        }
                        else if (Math.Abs(player.X - x) < 1000)
                        {
                            time_s = 2.5f;
                        }
                        else if (Math.Abs(player.X - x) < 1100)
                        {
                            time_s = 3.0f;
                        }
                        else
                        {
                            time_s = 3.5f;
                        }
                        if (Math.Abs(player.X - x) < 60)
                        {
                            time_s = 4.0f;
                        }
                        player.ShootPoint(x, y, player.CurrentBall.ID, 1001, 10001, 1, time_s, 3000);
                    }
                    else
                    {
                        player.Shoot(x, y, force, angle);
                    }
                }
            }
        }
    }
}
