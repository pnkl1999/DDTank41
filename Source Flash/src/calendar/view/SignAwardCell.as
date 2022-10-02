package calendar.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.DisplayObject;
   
   public class SignAwardCell extends BaseCell
   {
       
      
      private var _bigBack:DisplayObject;
      
      private var _nameField:FilterFrameText;
      
      private var _tbxCount:FilterFrameText;
      
      public function SignAwardCell()
      {
         super(ComponentFactory.Instance.creatBitmap("Calendar.SignedAward.CellBack"));
         this._bigBack = ComponentFactory.Instance.creatBitmap("Calendar.SignedAward.BigCellBack");
         addChildAt(this._bigBack,0);
         this._nameField = ComponentFactory.Instance.creatComponentByStylename("Calendar.AwardNameField");
         addChild(this._nameField);
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("SignedAwardCellCount");
         this._tbxCount.mouseEnabled = false;
         addChild(this._tbxCount);
      }
      
      public function setCount(param1:int) : void
      {
         if(param1 > 0)
         {
            this._tbxCount.text = param1.toString();
         }
         else
         {
            this._tbxCount.text = "";
         }
         this._tbxCount.x = 49 - this._tbxCount.width;
         this._tbxCount.y = 49 - this._tbxCount.height;
         setChildIndex(this._tbxCount,numChildren - 1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _picPos = ComponentFactory.Instance.creatCustomObject("Calendar.Award.pic.TopLeft");
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
         if(_info)
         {
            this._nameField.text = _info.Name;
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bigBack);
         this._bigBack = null;
         ObjectUtils.disposeObject(this._tbxCount);
         this._tbxCount = null;
         super.dispose();
      }
   }
}
