/*
  * @ComponentName	TFG_WhatsAppMessage_Wrapper
  * @description	Wrapper of json body for the API of WhatsApp
  * @author			FJMG
  * @email			fran19943@gmail.com
  * @version		V0.1
  * @dateCreated	2023/07/17
  * @lastChange		
*/

public class TFG_WhatsAppMessage_Wrapper {

	public String messaging_product;
	public String recipient_type;
	public String to;
	public String type;
	public Text text;

	public class Text {
		public Boolean preview_url;
		public String body;
	}
	
	public static TFG_WhatsAppMessage_Wrapper parse(String json) {
		return (TFG_WhatsAppMessage_Wrapper) System.JSON.deserialize(json, TFG_WhatsAppMessage_Wrapper.class);
	}
}