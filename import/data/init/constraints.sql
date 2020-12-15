--
-- Add the relevants constraints
--

ALTER TABLE `classify`
  ADD CONSTRAINT `fk_classify_genre` FOREIGN KEY (`idgenre`) REFERENCES `genre` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_classify_manga` FOREIGN KEY (`idmanga`) REFERENCES `manga` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `publish`
  ADD CONSTRAINT `fk_publish_magazine` FOREIGN KEY (`idmagazine`) REFERENCES `magazine` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_publish_manga` FOREIGN KEY (`idmanga`) REFERENCES `manga` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `write`
  ADD CONSTRAINT `fk_write_author` FOREIGN KEY (`idauthor`) REFERENCES `author` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_write_manga` FOREIGN KEY (`idmanga`) REFERENCES `manga` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;


SET session SQL_MODE=default; -- Restore the SQL_MODE to default
