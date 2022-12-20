package com.mongo.melon.mapper;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import javax.inject.Inject;

import org.bson.Document;
import org.bson.conversions.Bson;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Repository;

import com.mongo.melon.domain.MelonVO;
import com.mongo.melon.domain.SumVO;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;

@Repository
public class MelonMapperImpl implements MelonMapper {
	
	@Inject
	private MongoTemplate mTemplate;

	@Override
	public boolean createCollection(String colName) throws Exception {
		
		return false;
	}

	@Override
	public int insertMelon(List<MelonVO> mList, String colName) throws Exception {
		Collection<MelonVO> arr = mTemplate.insert(mList, colName);
		return arr.size();
	}

	@Override
	public List<MelonVO> getMelonList(String colName) throws Exception {
		
		return this.mTemplate.findAll(MelonVO.class, colName);
	}
	
	
	/*db.getCollection("Melon_20221219").aggregate(
		    [
		        {
		            "$group" : {
		                "_id" : {
		                    "singer" : "$singer"
		                },
		                "count" : {
		                    "$sum" : 1.0
		                }
		            }
		        }, 
		        {
		            "$project" : {
		                "singer" : "$_id.singer",
		                "cntBySinger" : "$count"
		            }
		        }
		    ],
		    {
		        "allowDiskUse" : false
		    }
		);
	*/
	
	//노래수가 2개 이상인 가수/노래 수 가져오기
			/*
			db.getCollection("Melon_20221219").aggregate(
			    [
			        {
			            "$group" : {
			                "_id" : {
			                    "singer" : "$singer"
			                },
			                "count" : {
			                    "$sum" : 1.0
			                }
			            }
			        }, 
			        {
			            "$project" : {
			                "singer" : "$_id.singer",
			                "cntBySinger" : "$count"
			            }
			        }, 
			        {
			            "$match" : {
			                "cntBySinger" : {
			                    "$gt" : 1.0
			                }
			            }
			        }, 
			        {
			            "$sort" : {
			                "cntBySinger" : -1.0
			            }
			        }
			    ], 
			    {
			        "allowDiskUse" : false
			    }
			);
			
			 */
	
	@Override
	public List<SumVO> getCntBySinger(String colName) throws Exception {
		MongoCollection<Document> col = mTemplate.getCollection(colName);
		
		List<? extends Bson> pipeline = Arrays.asList(
				new Document().append("$group", new Document().append("_id",
					new Document().append("singer", "$singer")).append("count", new Document().append("$sum", 1))),
				new Document().append("$project", new Document().append("singer", "$_id.singer").append("cntBySinger", "$count")),
				new Document().append("$match", new Document().append("cntBySinger", new Document().append("$gt", 1))),
				new Document().append("$sort", new Document().append("cntBySinger", -1))
				);
//		List<? extends Bson> pipeline=Arrays.asList(
//				new Document().append("$group", new Document().append("_id", 
//						new Document().append("singer", "$singer")).append("count", new Document().append("$sum", 1))),	
//				new Document().append("$project", new Document().append("singer", "$_id.singer").append("cntBySinger", "$count")),
//				new Document().append("$sort", new Document().append("cntBySinger", -1))
//					);
		
		

		AggregateIterable<Document> cr = col.aggregate(pipeline);
		List<SumVO> arr = new ArrayList<>();
		
		for(Document doc:cr) {
			if(doc==null) {
				doc = new Document();
			}
			String singer = doc.getString("singer");
			int cntBySinger = doc.getInteger("cntBySinger", 0); //key값이 없으면 디폴트 : 0으로 할당
			SumVO svo = new SumVO();
			svo.setSinger(singer);
			svo.setCntBySinger(cntBySinger);
			arr.add(svo);
			
		}
		
		return arr;
	}

	@Override
	public List<MelonVO> getMelonListBySinger(String colName, String singer) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
