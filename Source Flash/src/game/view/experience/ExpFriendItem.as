package game.view.experience
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import game.model.Player;
   import game.view.playerThumbnail.HeadFigure;
   
   public class ExpFriendItem extends Sprite implements Disposeable
   {
       
      
      private var _head:HeadFigure;
      
      private var _nameTxt:FilterFrameText;
      
      private var _expTxt:FilterFrameText;
      
      private var _exploitTxt:FilterFrameText;
      
      public function ExpFriendItem(param1:Player)
      {
         super();
         this.init(param1);
      }
      
      private function init(param1:Player) : void
      {
         var _loc2_:int = 0;
         this._head = new HeadFigure(28,28,param1);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("experience.LeftViewNameTxt");
         this._expTxt = ComponentFactory.Instance.creatComponentByStylename("experience.LeftViewScoreTxt");
         this._exploitTxt = ComponentFactory.Instance.creatComponentByStylename("experience.LeftViewScoreTxt");
         PositionUtils.setPos(this._exploitTxt,"experience.FriendItemTxtPos_3");
         PositionUtils.setPos(this._head,"experience.FriendItemHeadPos");
         this._nameTxt.text = param1.playerInfo.NickName;
         if(this._nameTxt.width > 85)
         {
            _loc2_ = this._nameTxt.getCharIndexAtPoint(85,5);
            this._nameTxt.text = this._nameTxt.text.substring(0,_loc2_) + "...";
         }
         this._expTxt.text = "+" + param1.expObj.gainGP;
         if(param1.expObj.gainOffer)
         {
            if(param1.GainOffer < 0)
            {
               this._exploitTxt.text = param1.GainOffer.toString();
            }
            else
            {
               this._exploitTxt.text = "+" + param1.GainOffer.toString();
            }
         }
         else
         {
            this._exploitTxt.text = "+0";
         }
         addChild(this._head);
         addChild(this._nameTxt);
         addChild(this._expTxt);
         addChild(this._exploitTxt);
      }
      
      public function dispose() : void
      {
         if(this._head)
         {
            this._head.dispose();
            this._head = null;
         }
         if(this._nameTxt)
         {
            this._nameTxt.dispose();
            this._nameTxt = null;
         }
         if(this._expTxt)
         {
            this._expTxt.dispose();
            this._expTxt = null;
         }
         if(this._exploitTxt)
         {
            this._exploitTxt.dispose();
            this._exploitTxt = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
