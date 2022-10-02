package game.view.experience
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   
   public class ExpAttatchExpItem extends ExpFightExpItem
   {
       
      
      public function ExpAttatchExpItem(param1:Array)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         _itemType = ExpTypeTxt.ATTATCH_EXP;
         PositionUtils.setPos(this,"experience.AttatchExpItemPos");
         _bg = ComponentFactory.Instance.creatBitmap("asset.experience.attachExpItemBg");
         _titleBitmap = ComponentFactory.Instance.creatBitmap("asset.experience.attachExpItemTitle");
         addChild(_bg);
         addChild(_titleBitmap);
      }
      
      override protected function createNumTxt() : void
      {
         _numTxt = new ExpCountingTxt("experience.expCountTxt1","experience.expTxtFilter_1,experience.expTxtFilter_2");
         _numTxt.addEventListener(Event.CHANGE,__onTextChange);
         addChild(_numTxt);
      }
   }
}
