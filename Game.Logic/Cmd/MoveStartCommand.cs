using Game.Base.Packets;
using Game.Logic.Phy.Object;
using System;

namespace Game.Logic.Cmd
{
    [GameCommand((byte)eTankCmdType.MOVESTART, "开始移动")]
    public class MoveStartCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
            if (!player.IsAttacking/* || !player.Config.IsMoving*/)
            {
                return;
            }
            bool recording = packet.ReadBoolean();
            byte type = packet.ReadByte();
            int x = packet.ReadInt();
            int y = packet.ReadInt();
            byte dir = packet.ReadByte();
            bool isLiving = packet.ReadBoolean();
            short map_currentTurn = packet.ReadShort();
            if (game.TurnIndex == map_currentTurn)
            {
            }
            game.SendPlayerMove(player, type, x, y, dir);
            byte b = type;
            byte b2 = b;
            if ((uint)b2 <= 1u)
            {
                player.SetXY(x, y);
                player.StartMoving();
                if (player.Y - y > 1 || player.IsLiving != isLiving)
                {
                    game.SendPlayerMove(player, 3, player.X, player.Y, dir, isLiving);
                }
            }
        }
    }
}
