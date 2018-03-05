package com.attendance.config;

import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.attendance.crypto.CryptoUtils;

public class AppConfigInfo {

	public static String xmlParser(String nodeName) {
		String configData = null;
		try {
			File inputFile = new File("D:/app-config-info.xml");
			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(inputFile);
			doc.getDocumentElement().normalize();

			NodeList nList = doc.getElementsByTagName("app");
			for (int temp = 0; temp < nList.getLength(); temp++) {
				Node nNode = nList.item(temp);

				if (nNode.getNodeType() == Node.ELEMENT_NODE) {
					Element eElement = (Element) nNode;
					configData = eElement.getElementsByTagName(nodeName).item(0).getTextContent();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return configData;
	}

	public static void ModifyXML(String nodeName, String new_password) {
		try {
			File inputFile = new File("D:/app-config-info.xml");
			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(inputFile);
			Node app = doc.getElementsByTagName("app").item(0);
			NodeList list = app.getChildNodes();
			
			for (int temp = 0; temp < list.getLength(); temp++) {
				Node node = list.item(temp);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) node;
					if (nodeName.equals(element.getNodeName())) {
						element.setTextContent(CryptoUtils.doEncrypt(new_password));
					}
				}
			}
			
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			DOMSource source = new DOMSource(doc);
			StreamResult Result = new StreamResult(inputFile);
			transformer.transform(source, Result);
		} catch (Exception e) {

		}
	}

	public static String getUserName() {
		return xmlParser("user-name");
	}

	public static String getDefaultStorage() {
		return xmlParser("default-storage");
	}

	public static String getPassword() {
		return xmlParser("password");
	}

	public static String getFullWorkingHours() {
		return xmlParser("full-working-hours");
	}

	public static String getHalfWorkingHours() {
		return xmlParser("half-working-hours");
	}
}
