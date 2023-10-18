@IsTest
public class TFG_WhatsAppMessage_WrapperTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"messaging_product\": \"whatsapp\",'+
		'    \"recipient_type\": \"individual\",'+
		'    \"to\": \"34671481834\",'+
		'    \"type\": \"text\",'+
		'    \"text\": {'+
		'        \"preview_url\": true,'+
		'        \"body\": \"PRUEBAAAAAAAAAAAAAAA\"'+
		'	}'+
		'}';

		TFG_WhatsAppMessage_Wrapper obj = TFG_WhatsAppMessage_Wrapper.parse(json);
		System.assert(obj != null);
	}
}