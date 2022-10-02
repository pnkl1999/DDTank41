package inviteFriends.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.ItemTemplateInfo;
   
   public class InviteFriendItemCell extends BagCell
   {
       
      
      public var count:int;
      
      public function InviteFriendItemCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true)
      {
         super(param1,param2,param3,ComponentFactory.Instance.creatBitmap("inviteFriends.view.rewardCellBgAsset"),false);
      }
      
      override public function updateCount() : void
      {
         if(_tbxCount)
         {
            if(info && this.count > 1)
            {
               _tbxCount.text = String(this.count);
               _tbxCount.visible = true;
               addChild(_tbxCount);
            }
            else
            {
               _tbxCount.visible = false;
            }
         }
      }
   }
}
